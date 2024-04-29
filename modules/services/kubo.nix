{ ... }:
{
  services.kubo = {
    settings = {
      API.HTTPHeaders = {
        Access-Control-Allow-Origin = [ "*" ];
      };
    };
  };
}
