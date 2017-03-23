using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using enti_api.Code;

namespace enti_api.Controllers
{
    public class OrderController : ApiController
    {
        // GET: api/Order
        [BasicAuthenticationAttribute]
        public List<Models.Orders> Get()
        {
            var orders = new List<Models.Orders>();

            using (var db = new EntiTreesEntities())
            {
                var query = db.SelectOrders();

                foreach (var item in query)
                {
                    orders.Add(new Models.Orders
                    {
                        orderId = item.Id,
                        customerId = item.CustomerId,
                        shoppingCartId = item.ShoppingCartId,
                        orderDate = item.Date,
                        isCompleted = item.IsCompleted,
                        itemsCount = item.Quantity == null ? 0 : item.Quantity.Value,
                        message = item.Message,
                        totalPrice = item.TotalPrice == null ? 0 : item.TotalPrice.Value,
                        orderCompletedDate = item.DateCompleted
                    });
                }
            }

            return orders;
        }

        // GET: api/Order/5
        [BasicAuthenticationAttribute]
        public Models.OrderDetails Get(int orderId)
        {
            var order = new Models.OrderDetails();

            using (var db = new EntiTreesEntities())
            {
                var query = db.SelectOrderByID(orderId);
                foreach (var item in query)
                {
                    order.orderId = item.OrderId;
                    order.shoppingCartId = item.ShoppingCartId;
                    order.customerId = item.CustomerId;
                    order.orderDate = item.Date;
                    order.isCompleted = item.IsCompleted;
                    order.orderCompletedDate = item.DateCompleted;
                    order.customer = new Models.Customer
                    {
                        message = item.Message,
                        name = item.Name,
                        phone = item.Phone,
                        email = item.Email,
                        address = item.Address
                    };
                }

                var query2 = db.SelectOrderItemsByOrderID(orderId);
                order.items = new List<Models.OrderDetails.OrderItem>();
                foreach (var item in query2)
                {
                    order.items.Add(new Models.OrderDetails.OrderItem
                    {
                        shoppingItemId = item.ShoppingItemId,
                        categoryName = item.Name,
                        discount = item.Discount == null ? 0 : item.Discount.Value,
                        imageSrc = item.ImageSrc,
                        itemPrice = item.SinglePrice == null ? 0 : item.SinglePrice.Value,
                        quantity = item.Quantity,
                        sellPrice = item.Price,
                        title = item.Title
                    });
                }
            }
           
            return order;
        }

        private Func<ObjectResult<object>> ObjectResult()
        {
            throw new NotImplementedException();
        }

        // POST: api/Order
        //Content-Type: application/json
        public Models.ReturnValue<string> Post(Models.Order order)
        {
            string inXml = Utils.ObjectToXML(order);
            using (var db = new EntiTreesEntities())
            {                
                try
                {
                    foreach(Models.OrderItem item in order.shoppingCart)
                    {
                        if(item.quantity > item.item.quantity)
                        {
                            return new Models.ReturnValue<string>(Models.Codes.NotEnoughQty, "There is not enough quantity for this item " + item.item.title);
                        }
                    }

                    var result = db.InsertNewOrder(inXml);
                    Models.ReturnValue<string> returnVal;

                    foreach (var item in result)
                    {
                        //if the order is successfull
                        Models.Codes code = (Models.Codes)Enum.Parse(typeof(Models.Codes), item.Result);
                        returnVal = new Models.ReturnValue<string>(code, item.ResultMessage);
                        Utils.SendMail("ПОРЪЧКА #" + item.OrderID.ToString() + ": Нова поръчка е изпратена успешно!", GenerateOrderEmailBody(order, item.OrderID.ToString()), order.customer.email, order.customer.name);
                        return returnVal;
                    }
                    return new Models.ReturnValue<string>(Models.Codes.DBError, "There is something wrong with the DB");
                }
                catch (Exception ex)
                {
                    return new Models.ReturnValue<string>(Models.Codes.Error, ex.Message);
                }
            }
        }

        // PUT: api/Order/5
        // Update of order status
        [BasicAuthenticationAttribute]
        public void Put(int id, bool isCompleted)
        {
            using (var db = new EntiTreesEntities())
            {
                db.UpdateOrder(id, isCompleted);
            }
        }

        #region private methods
        /// <summary>
        /// Generates the body of the email that is sent to the user when new order is submitted.
        /// </summary>
        /// <param name="order">The new order to the system</param>
        /// <returns></returns>
        private string GenerateOrderEmailBody(Models.Order order, string orderNumber)
        {
            //TODO: add item images and ENTI LOGO
            string body = @"<!DOCTYPE html>
                            <html xmlns=""http://www.w3.org/1999/xhtml"">
                            <head>
                                <meta http-equiv=""Content-Type"" content=""text/html; charset=UTF-8"" />
                                <title>Нова поръчка от Enti Tree Bonsai</title>
                                <meta name=""viewport"" content=""width=device-width, initial-scale=1.0"" />
                            </head>
                            </body>" + 
                    "Здравейте, " + order.customer.name + "!<br/><br/>" +
                    "Поръчка #" + orderNumber + " е регистрирана успешно. Очаквайте да се свържем с Вас за потвърждение на поръчката Ви.<br/>" +
                    "Ще получите още един емайл, когато поръчката Ви бъде изпратена на посочения от вас адрес: " + order.customer.address +
                    "<br/><br/><h3> Детайли за поръчката: </h3><br/>";
            body += @"<table style=""width:100%;border-spacing:0;border: 1px solid #eee;border-radius: 10px;padding: 5px;line-height: 20px;"">
                        <thead>
                            <tr style=""background-color: #eee;"">
                               <th style=""text-align: left; padding: 5px;"">Продукт </th>
                               <th style=""text-align: right; padding: 5px;"">Количество </th>
                               <th style=""text-align: right; padding: 5px;"">Цена </th>
                            </tr>
                        </thead>
                        <tbody>";
            double? total = 0;
            double? itemPrice = 0;
            for (int i = 0; i < order.shoppingCart.Count; i++)
            {
                itemPrice = ((order.shoppingCart[i].item.price - order.shoppingCart[i].item.price * order.shoppingCart[i].item.discount / 100) * order.shoppingCart[i].quantity);

                body += "<tr><td>" + order.shoppingCart[i].item.title + "</td><td style=\"text-align: right;\">" + 
                    order.shoppingCart[i].quantity + "</td><td style=\"text-align: right;\">" +
                    itemPrice.Value.ToString() +
                    " лв. </td></tr>";
                total += itemPrice;
            }
            string contactsUrl = System.Web.Configuration.WebConfigurationManager.AppSettings.Get("entiTreesUrl") + "contacts";

            body += @"<tfoot><tr><td colspan=""3""><hr style=""border-top: 1px solid #eee;""></td></tr>
                        <tr style=""border-top: 1px solid #eee""><td colspan=""2"">Обща цена на поръчката:</td><td style=""text-align: right;"">" +
                            total.ToString() +
                        @" лв. </td></tr>
                      </tfoot>
                      </tbody>
                      </table>
                      <br/><br/>
                    Детайли за доставката можете да откриете на страницата <a href=""" + contactsUrl + @""">Контакти</a> на нашия сайт.
                    <br/> Благодарим Ви, че избрахте нас!
                    </body>
                    </html>";
            return body;
        }

        #endregion
    }
}
