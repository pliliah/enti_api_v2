using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace enti_api.Models
{
    public class Login
    {
        //the username
        public string user { get; set; }
        //base64 encoded nonce
        public string nonce { get; set; }
        //date in iso format "yyyy-MM-ddTHH:mm:ssZ"
        public string date { get; set; }
        //base64 encrypted md5 sum of nonce + created + password
        public string digest { get; set; }
    }
}