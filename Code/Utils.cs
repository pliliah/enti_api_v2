using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using System.Xml;
using System.Xml.Serialization;
using System.Net;
using System.Net.Mail;

namespace enti_api.Code
{
    public static class Utils
    {
        /// <summary>
        /// Converts the specified object to XML file that is used to be send to the DB
        /// </summary>
        /// <param name="o">The object that has to be converted to XML</param>
        /// <returns></returns>
        public static string ObjectToXML(object o)
        {
            StringWriter sw = new StringWriter();
            XmlTextWriter tw = new XmlTextWriter(sw);
            try
            {
                XmlSerializer serializer = new XmlSerializer(o.GetType());   
                serializer.Serialize(tw, o);
                var result = sw.ToString();
                result = result.Remove(0, result.IndexOf("?>") + 2);
                return result;
            }
            catch (Exception ex)
            {
                //Handle Exception Code
                return "";
            }
            finally
            {
                sw.Close();
                tw.Close();
            }
        }

        /// <summary>
        /// Sends email over Gmail from the email of the site
        /// </summary>
        /// <param name="m_subject">Subject of the email</param>
        /// <param name="m_body">Email body</param>
        /// <param name="m_receiverEmail">Email of the receiver</param>
        /// <param name="m_receiverName">Name of the receiver</param>
        public static void SendMail(string m_subject, string m_body, string m_receiverEmail, string m_receiverName)
        {
            //TODO: put email credentials in web.config
            string mailFrom = System.Web.Configuration.WebConfigurationManager.AppSettings.Get("adminEmail");
            var fromAddress = new MailAddress(mailFrom, "Enti Tree Bonsai");
            var toAddress = new MailAddress(m_receiverEmail, m_receiverName);
            string fromPassword = System.Web.Configuration.WebConfigurationManager.AppSettings.Get("adminEmailPwd");

            var smtp = new SmtpClient
            {
                Host = "smtp.gmail.com",
                Port = 587,
                EnableSsl = true,
                DeliveryMethod = SmtpDeliveryMethod.Network,
                UseDefaultCredentials = false,
                Credentials = new NetworkCredential(fromAddress.Address, fromPassword),
                Timeout = 20000
            };
            using (var message = new MailMessage(fromAddress, toAddress)
            {
                Subject = m_subject,
                Body = m_body
            })
            {
                message.IsBodyHtml = true;
                message.CC.Add(fromAddress);
                smtp.Send(message);
            }
        }
    }
}