#[macro_use] extern crate hyper;

use std::error::Error;
use std::io::Read;
use std::process;
use std::env;

extern crate rustc_serialize;

use rustc_serialize::json;

use hyper::Client;
use hyper::header::Headers;
header! { (Token, "Authorization") => [String]}


fn make_call(url_path: String) -> Result<String, Box<Error+Send+Sync>>{
    let client = Client::new();

    let mut auth_head = Headers::new();

    auth_head.set(Token(TOKEN.to_owned()));

    let url = URL_ROOT.to_owned() + &url_path;

    let mut res = try!(client.get(&url)
        .headers(auth_head)
        .send());

    // if it's not a 200 then error out
    match res.status{
        hyper::status::StatusCode::Ok => {
            let mut body: String = String::new();
            try!(res.read_to_string(&mut body));
            Ok(body)},
        
        _ => Err(From::from(format!("{}", res.status)))
    }
}

fn incidents(){
    let body: String;
    
    match make_call(String::from("incidents?status=triggered,acknowledged")){
        Ok(bod) => body = bod,
        Err(err) => {println!("{}", err);
                     process::exit(1)}
    }

    // deserialize json
    let request_json = json::Json::from_str(&body).unwrap();

    let response_obj = request_json.as_object().unwrap();

    // unwrap is fine because there should always be incidents object
    let incidents = response_obj.get("incidents").unwrap();

    // unwrap is fine because it s
    let incidents_obj = incidents.as_array().unwrap();

    enum Status {
        ACKNOWLEDGED,
        TRIGGERED,
        UNKNOWN
    }

    let mut ack: i32 = 0;
    let mut trig: i32 = 0;
    
    let statuses  = incidents_obj.iter()
        .map(|incident| {match incident.as_object().unwrap().get("status").unwrap().as_string().unwrap(){
            "acknowledged" => Status::ACKNOWLEDGED,
            "triggered" => Status::TRIGGERED,
            _ => Status::UNKNOWN}})
        .collect::<Vec<_>>();

    for status in &statuses{
        match status{
            &Status::ACKNOWLEDGED => ack += 1,
            &Status::TRIGGERED => trig += 1,
            &Status::UNKNOWN => panic!("Unknown Status")}
    };
    
    let mut output: String = "".to_owned();
    let mut exit_code: i32 = 0;

    if ack > 0{
        output.push_str(&format!(": {}", ack));
    }

    if trig > 0 {
        output.push_str(&format!(": {}", trig));
        exit_code = 33;
    }
    println!("{}", output);
    println!("{}", output);
    println!("#FFFF00");
    process::exit(exit_code);
}

fn call_loop(){
    println!("On Call");
    println!("On Call");
    process::exit(33);

}

fn oncall(){
    let body: String;
    
    match make_call(String::from("users/on_call")){
        Ok(bod) => body = bod,
        Err(err) => {println!("{}", err);
                     process::exit(1)}
    }
    
    // deserialize json
    let request_json = json::Json::from_str(&body).unwrap();
    let response_obj = request_json.as_object().unwrap();

    let users = response_obj.get("users").unwrap();
    let users_array = users.as_array().unwrap();

    let target_user = users_array.iter().filter(|x| x.as_object().unwrap()
                                                .get("id").unwrap()
                                                .as_string().unwrap() == "PYHMPK3").collect::<Vec<_>>();

    for user in &target_user{
        let calls = user.as_object().unwrap()
            .get("on_call").unwrap()
            .as_array().unwrap();
        for call in calls.iter(){
            let call_obj = call.as_object().unwrap();
            if call_obj.get("level").unwrap().as_i64().unwrap() == 1{
                let escalation_policy = call_obj.get("escalation_policy").unwrap()
                    .as_object().unwrap()
                    .get("id").unwrap()
                    .as_string().unwrap();
                if escalation_policy == "P6OGX5C"{
                    call_loop();
                }
            }
        }
    }
}




fn main(){
    if let Ok(s) = env::var("BLOCK_BUTTON"){
        if s == "1"{
            let _ = process::Command::new("xdg-open").arg("https://infectiousmedia.pagerduty.com/incidents").output().unwrap_or_else(|e| { panic!("failed to execute process: {}", e)} );
        }
    }

    let args: Vec<String> = env::args().collect();
    if args.iter().any(|x| x == "on_call"){
        oncall();
    }

    if args.iter().any(|x| x == "incidents"){
        incidents();
    }
  
}
