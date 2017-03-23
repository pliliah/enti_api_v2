using enti_api.Code;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace enti_api.Controllers
{
    public class CustomerController : ApiController
    {
        // GET: api/Order
        /// <summary>
        /// Returns all the customers that have bought something from the shop.
        /// This must be updated with information about how many items they have purchased and so on.
        /// </summary>
        /// <returns></returns>
        [BasicAuthenticationAttribute]
        public List<Models.Customer> Get()
        {
            var customers = new List<Models.Customer>();

            using (var db = new EntiTreesEntities())
            {
                var query = db.SelectCustomers();

                foreach (var item in query)
                {
                    customers.Add(new Models.Customer
                    {
                        id =  item.Id,
                        name = item.Name,
                        email = item.Email,
                        phone = item.Phone,
                        address = item.Address,
                        ordersCount = item.OrdersCount
                    });
                }
            }

            return customers;
        }
    }
}
