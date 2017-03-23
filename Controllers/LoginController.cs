using enti_api.Code;
using System.Web.Http;

namespace enti_api.Controllers
{
    public class LoginController : ApiController
    {       
        // POST: api/Login
        public Models.ReturnValue<string> Post([FromBody]Models.Login login)
        {            
            if (Authentication.CheckCredentials(login.user, login.nonce, login.digest, login.date))
            {
                //login successfull
                return new Models.ReturnValue<string>(Models.Codes.Accepted, "User logged in successfully!");
            }
            else
            {
                //login not successfull
                return new Models.ReturnValue<string>(Models.Codes.Unauthorized, "Credentials not valid. Login unsuccessfull!");
            }
        }

        //// PUT: api/Login/5
        //public void Put(int id, [FromBody]string value)
        //{
        //}

        //// DELETE: api/Login/5
        //public void Delete(int id)
        //{
        //}
    }
}
