using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace enti_api.Controllers
{
    public class CategoriesController : ApiController
    {

        // GET: api/Categories/5
        public List<Models.Category> Get()
        {
            var categories = new List<Models.Category>();

            using (var db = new EntiTreesEntities())
            {
                var query = db.SelectCategories();

                foreach (var item in query)
                {
                    categories.Add(new Models.Category
                    {
                        id = item.Id,
                        name = item.Name,
                        description = item.Description,
                        imageSrc = item.ImgSrc,
                        src = item.Src,
                        itemsCount = item.ItemsCount,
                        systemName = item.SystemName
                    });
                }
            }

            return categories;
        }
    }
}
