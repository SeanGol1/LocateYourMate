using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PRJ300Rep
{
    public class MarkerLocation
    {
        public string Type { get; set; }
        public string Lat { get; set; }
        public string Lng { get; set; }


        public MarkerLocation()
        {

        }

        public MarkerLocation(string type, string lat, string lng)
        {
            Type = type;
            Lat = lat;
            Lng = lng;
        }
    }
}