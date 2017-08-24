using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PRJ300Rep
{
    public class User
    {
        public string name { get; set; }
        public string latitude { get; set; }
        public string longitude { get; set; }

        public User(string nme, string lat, string lng)
        {
            name = nme;
            latitude = lat;
            longitude = lng;
        }
    }
}