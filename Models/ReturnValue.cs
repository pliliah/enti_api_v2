using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace enti_api.Models
{
    public class ReturnValue<T>
    {
        public Codes code { get; set; }
        public string message { get; set; }
        public T data { get; set; }

        public ReturnValue(Codes code, string message)
        {
            this.code = code;
            this.message = message;
        }

        public ReturnValue(Codes code, string message, T data)
        {
            this.code = code;
            this.message = message;
            this.data = data;
        }
    }

    public enum Codes
    {
        OK = 200,
        Created = 201,
        Accepted = 202, //login successfull
        NoContent = 204,
        Unauthorized = 401, //unsuccessfull login
        Forbidden = 403, //when the user tries to access resources when he is not logged in
        Error = 500,
        DBError = 506,
        NotEnoughQty = 507 //not enough items in the shop for the specified quantity
    }
    
}