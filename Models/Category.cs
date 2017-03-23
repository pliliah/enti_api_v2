using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace enti_api.Models
{
    public class Category
    {
        public int id { get; set; }
        public string name { get; set; }
        public string description { get; set; }
        public string systemName { get; set; }
        public string src { get; set; }
        public string imageSrc { get; set; }
        public int? itemsCount { get; set; }
    }
}