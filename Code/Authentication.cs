using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;

namespace enti_api.Code
{
    public static class Authentication
    {
        public static bool CheckCredentials(string a_user, string a_nonce, string a_digest, string a_created)
        {
            try {
                byte[] nonce = Convert.FromBase64String(a_nonce);
                string decodedNonce = Encoding.UTF8.GetString(nonce);
                //TODO: get credentials from the DB
                // given, a password in a string
                var adminUser = System.Web.Configuration.WebConfigurationManager.AppSettings.Get("adminUser");
                if(adminUser != a_user)
                {
                    return false;
                }

                string password = System.Web.Configuration.WebConfigurationManager.AppSettings.Get("adminPwd"); //get the password for that user from the DB

                // byte array representation of that string
                byte[] encodedPassword = new UTF8Encoding().GetBytes(decodedNonce + a_created + password);

                // need MD5 to calculate the hash
                byte[] hash = ((HashAlgorithm)CryptoConfig.CreateFromName("MD5")).ComputeHash(encodedPassword);
                // string representation (similar to UNIX format)
                string encoded = BitConverter.ToString(hash)
                   // without dashes
                   .Replace("-", string.Empty)
                   // make lowercase
                   .ToLower();

                var encodedBytes = System.Text.Encoding.UTF8.GetBytes(encoded);
                string encodedToBase64 = Convert.ToBase64String(encodedBytes);

                if (encodedToBase64 == a_digest)
                {
                    //login successfull
                    return true;
                }
                else
                {
                    //login not successfull
                    return false;
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }
    }
}