using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PRJ300Rep
{
    public class UserLocation
    {

        public string Username { get; set; }
        public string Lat{ get; set; }
        public string Lng { get; set; }


        public UserLocation()
        {

        }

        public UserLocation(string name, string lat, string lng)
        {
            Username = name;
            Lat = lat;
            Lng = lng;
        }

    }
}