using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace enti_api.Controllers
{
    public class ContactController : ApiController
    {
        // POST: api/Order
        //Content-Type: application/json
        public Models.ReturnValue<string> Post(Models.Contact contact)
        {
            using (var db = new EntiTreesEntities())
            {
                try
                {
                    db.InsertContact(contact.name, contact.email, contact.phone, contact.message);

                    return new Models.ReturnValue<string>(Models.Codes.Created, "The contact message inserted successfully.");
                }
                catch (Exception ex)
                {
                    return new Models.ReturnValue<string>(Models.Codes.DBError, ex.Message);
                }
            }
        }
    }
}
