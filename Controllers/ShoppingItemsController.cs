using enti_api.Code;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace enti_api.Controllers
{
    public class ShoppingItemsController : ApiController
    {
       
        // GET: api/ShoppingItems?categoryId=5
        /// <summary>
        /// Gets all shopping items for the specified category
        /// </summary>
        /// <param name="categoryId"></param>
        /// <returns></returns>
        public List<Models.ShoppingItem> Get(int? categoryId)
        {
            var items = new List<Models.ShoppingItem>();

            using (var db = new EntiTreesEntities())
            {
                var query = db.SelectShoppingItems(categoryId, null);

                foreach (var item in query)
                {
                    items.Add(new Models.ShoppingItem
                    {
                       id = item.Id,
                       description = item.Description,
                       discount = item.Discount,
                       lastUpdated = item.LastModified,
                       price = item.Price,
                       quantity = item.Quantity,
                       src = item.ImageSrc,
                       title = item.Title,
                       categoryId = item.CategoryId
                    });
                }
            }

            return items;
        }

        // GET: api/ShoppingItems?itemId=5
        /// <summary>
        /// Gets the shopping item by it's ID
        /// </summary>
        /// <param name="itemId"></param>
        /// <returns></returns>
        public Models.ShoppingItem Get(int itemId)
        {
            var it = new Models.ShoppingItem();

            using (var db = new EntiTreesEntities())
            {
                var query = db.SelectShoppingItems(null, itemId);

                foreach (var item in query)
                {
                    it = new Models.ShoppingItem
                    {
                        id = item.Id,
                        description = item.Description,
                        discount = item.Discount,
                        lastUpdated = item.LastModified,
                        price = item.Price,
                        quantity = item.Quantity,
                        src = item.ImageSrc,
                        title = item.Title,
                        categoryId = item.CategoryId
                    };
                }
            }

            return it;
        }

        //create shopping item
        // POST: api/ShoppingItems
        [BasicAuthenticationAttribute]
        public void Post([FromBody]Models.ShoppingItem item)
        {
            using (var db = new EntiTreesEntities())
            {
                db.InsertNewShopItem(item.title, item.description, item.price, item.discount, item.src, item.quantity, item.categoryId);               
            }
        }

        //update shopping item
        // PUT: api/ShoppingItems/5
        [BasicAuthenticationAttribute]
        public void Put([FromBody]Models.ShoppingItem item)
        {
            using (var db = new EntiTreesEntities())
            {
                db.UpdateShopItem(item.id, item.title, item.description, item.price, item.discount, item.src, item.quantity, item.categoryId);
            }
        }

        // DELETE: api/ShoppingItems/5
        [BasicAuthenticationAttribute]
        public void Delete(int id)
        {
            using (var db = new EntiTreesEntities())
            {
                try
                {
                    var result = db.DeleteShopItem(id);
                }
                catch (Exception ex)
                {

                }
                
            }
        }
    }
}
