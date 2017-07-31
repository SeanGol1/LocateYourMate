using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(PRJ300Rep.Startup))]
namespace PRJ300Rep
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
