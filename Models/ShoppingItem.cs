using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace enti_api.Models
{
    public class ShoppingItem
    {
        public int id { get; set; }
        public string title { get; set; }
        public string description { get; set; }
        public double price { get; set; }
        public int? discount { get; set; }
        public DateTime lastUpdated { get; set; }
        public string src { get; set; }
        public int quantity { get; set; }
        public int categoryId { get; set; }
    }
}