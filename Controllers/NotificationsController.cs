using enti_api.Code;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace enti_api.Controllers
{
    public class NotificationsController : ApiController
    {
        // GET: api/Order
        [BasicAuthenticationAttribute]
        public Models.Notifications Get()
        {
            Models.Notifications notifications;

            using (var db = new EntiTreesEntities())
            {
                var query = db.SelectAdminHomeNotifications().FirstOrDefault();
                notifications = new Models.Notifications
                {
                    activeItems = query.ActiveItems.HasValue ? query.ActiveItems.Value : 0,
                    allItems = query.AllItems.HasValue ? query.AllItems.Value : 0,
                    allContacts = query.AllContacts.HasValue ? query.AllContacts.Value : 0,
                    openContacts = query.OpenContacts.HasValue ? query.OpenContacts.Value : 0,
                    openOrders = query.OpenOrders.HasValue ? query.OpenOrders.Value : 0,
                    allOrders = query.AllOrders.HasValue ? query.AllOrders.Value : 0,
                    customersCount = query.CustomersCount.HasValue ? query.CustomersCount.Value : 0
                };

                return notifications;
            }

            
        }
    }
}
