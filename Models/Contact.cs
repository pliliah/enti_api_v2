using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace enti_api.Models
{
    public class Contact
    {
        public string name { get; set; }
        public string email { get; set; }
        public string phone { get; set; }
        public string message { get; set; }
        public bool isCompleted { get; set; }
        public DateTime date { get; set; }
        public DateTime? dateCompleted { get; set; }
        public int contactId { get; set; }
        public string answer { get; set; }
    }
}