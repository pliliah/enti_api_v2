using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace enti_api.Models
{
    public class Notifications
    {
        public int activeItems { get; set; }
        public int allItems { get; set; }
        public int openOrders { get; set; }
        public int allOrders { get; set; }
        public int customersCount { get; set; }
        public int openContacts { get; set; }
        public int allContacts { get; set; }
    }
}