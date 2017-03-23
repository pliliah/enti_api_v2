using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;

namespace enti_api.Code
{
    public class BasicAuthenticationAttribute: ActionFilterAttribute
    {
        public override void OnActionExecuting(HttpActionContext actionContext)
        {
            var headers = actionContext.Request.Headers;
            IEnumerable<string> users, nonces, createdDates, digests;
            string user = null, 
                nonce = null, 
                createdDate = null, 
                digest = null;
            if (actionContext.Request.Headers.TryGetValues("X-Auth-User", out users) && users.First().Length > 0)
            {
                user = users.First().Trim('"');
            }
            if (actionContext.Request.Headers.TryGetValues("X-Auth-Nonce", out nonces) && nonces.First().Length > 0)
            {
                nonce = nonces.First().Trim('"');
            }
            if (actionContext.Request.Headers.TryGetValues("X-Auth-Created", out createdDates) && createdDates.First().Length > 0)
            {
                createdDate = createdDates.First().Trim('"');
            }
            if (actionContext.Request.Headers.TryGetValues("X-Auth-Digest", out digests) && digests.First().Length > 0)
            {
                digest = digests.First().Trim('"');
            }

            if(user != null && nonce != null && createdDate != null && digest != null)
            {
                //check user credentials here and if it's ok continue to the request
                if (Authentication.CheckCredentials(user, nonce, digest, createdDate))
                {                    
                    base.OnActionExecuting(actionContext);
                }
                else
                {
                    actionContext.Response = new System.Net.Http.HttpResponseMessage(System.Net.HttpStatusCode.Unauthorized);
                }
            }
            else
            {
                actionContext.Response = new System.Net.Http.HttpResponseMessage(System.Net.HttpStatusCode.Unauthorized);
            }
            
        }
               
    }
}