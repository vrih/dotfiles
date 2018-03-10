#[macro_use] extern crate hyper;

use std::error::Error;
use std::io::Read;
use std::process;
use std::env;

extern crate rustc_serialize;

use rustc_serialize::json;

use hyper::Client;
use hyper::header::{Headers, Accept, qitem};
use hyper::mime::{Mime, TopLevel, SubLevel, Attr, Value};

header! { (Token, "Authorization") => [String]}

const URL_ROOT: &'static str = "https://api.pagerduty.com/";

fn make_call(url_path: String) -> Result<String, Box<Error+Send+Sync>>{
    let client = Client::new();

    let mut auth_head = Headers::new();

    auth_head.set(Token(TOKEN.to_owned()));
    auth_head.set(Accept(vec![qitem(Mime(TopLevel::Application,
                                         SubLevel::Ext("vnd.pagerduty+json".to_owned()),
                                         vec![(Attr::Ext("version".to_owned()),
                                               Value::Ext("2".to_owned()))]))]));

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
    
    match make_call(String::from("incidents?statuses%5B%5D=triggered&statuses%5B%5D=acknowledged")){
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
    // TODO: change endpoint
    match make_call(String::from("oncalls?time_zone=UTC&user_ids%5B%5D=PYHMPK3&escalation_policy_ids%5B%5D=P6OGX5C&schedule_ids%5B%5D=PQJ4RJ7")){
        Ok(bod) => body = bod,
        Err(err) => {println!("{}", err);
                     process::exit(1)}
    }
    
    // deserialize json
    let request_json = json::Json::from_str(&body).unwrap();
    let response_obj = request_json.as_object().unwrap();

    let oncalls = response_obj.get("oncalls").unwrap();
    let oncalls_array = oncalls.as_array().unwrap();

    if oncalls_array.len() > 0{
        call_loop();
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
