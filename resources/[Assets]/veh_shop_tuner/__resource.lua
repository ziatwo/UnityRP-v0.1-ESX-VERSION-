resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

dependencies {
  "PolyZone"
}

server_script { 
  '@mysql-async/lib/MySQL.lua',
  'vehshop_s.lua'
}

client_scripts {
    "@PolyZone/client.lua",
    "@urp-errorlog/client/cl_errorlog.lua",
    "vehshop.lua"
  }