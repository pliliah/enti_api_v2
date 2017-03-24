using enti_api.Code;
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

        // GET: api/Contact
        [BasicAuthenticationAttribute]
        public List<Models.Contact> Get()
        {
            var contacts = new List<Models.Contact>();

            using (var db = new EntiTreesEntities())
            {
                var query = db.SelectContacts();

                foreach (var item in query)
                {
                    contacts.Add(new Models.Contact
                    {
                        contactId = item.Id,
                        email = item.Email,
                        name = item.Name,
                        phone = item.Phone,
                        isCompleted = item.IsCompleted.HasValue ? item.IsCompleted.Value : false,
                        date = item.Date,
                        message = item.Message,
                        dateCompleted = item.DateCompleted,
                        answer = item.Answer
                    });
                }
            }

            return contacts;
        }

        // POST: api/Contact
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

        // PUT: api/Contact/5
        // Update of contact status
        [BasicAuthenticationAttribute]
        public void Put(int id, bool isCompleted, string answer)
        {
            using (var db = new EntiTreesEntities())
            {
                db.UpdateContact(id, isCompleted, answer);
            }
        }

        // PUT: api/Contact/5
        // Send the contact a message
        [BasicAuthenticationAttribute]
        public Models.ReturnValue<string> Put(int id, string email, string name, string message)
        {
            using (var db = new EntiTreesEntities())
            {
                try
                {
                    Utils.SendMail("Отговор на запитване от Енти Трийс", message, email, name);
                    db.UpdateContact(id, true, message);
                    return new Models.ReturnValue<string>(Models.Codes.OK, "Successfully send message back to contact.");
                }
                catch (Exception ex)
                {
                    db.UpdateContact(id, false, "");
                    return new Models.ReturnValue<string>(Models.Codes.Error, ex.Message);
                }
            }
        }
    }
}
