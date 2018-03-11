#[macro_use] extern crate hyper;
extern crate hyper_tls;
extern crate tokio_core;
extern crate futures;
extern crate serde_json;

use std::error::Error;
//use std::io::Read;
use std::process;
use std::env;

extern crate rustc_serialize;

//use serde_json;
use serde_json::Value;
 
use hyper::{Client, Request, Method};
use hyper::header::{Accept, qitem};
use hyper_tls::HttpsConnector;

use futures::{Future, Stream};

use tokio_core::reactor::Core;

header! { (Token, "Authorization") => [String]}

const URL_ROOT: &'static str = "https://api.pagerduty.com/";

fn print_incidents(body: hyper::Chunk) -> Result<(), hyper::Error>{
    // deserialize json
    let request_json: Value = serde_json::from_slice(&body).unwrap();

    // unwrap is fine because there should always be incidents object
    let incidents = &request_json["incidents"];

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
        .map(|incident| {
            match incident["status"].as_str().unwrap(){
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

fn print_oncall(body: hyper::Chunk) -> Result<(), hyper::Error>{
    let request_json: Value = serde_json::from_slice(&body).unwrap();

    let oncalls = &request_json["oncalls"];
    let oncalls_array = oncalls.as_array().unwrap();

    if oncalls_array.len() > 0{
         call_loop();
    }
    Ok(())
}

fn make_call<F>(url_path: &str, mut f: F) -> Result<(), Box<Error+Send+Sync>>
    where F: FnMut(hyper::Chunk) -> Result<(), hyper::Error>{
    let mut core = Core::new()?;
    
    let handle = core.handle();

    let client = Client::configure()
        .connector(HttpsConnector::new(4, &handle)?)
        .build(&handle);
    
    let mut url: std::string::String = URL_ROOT.to_owned();
    url.push_str(url_path);

    let mut req = Request::new(Method::Get, url.parse()?);
    let mut token = String::from("Token token=");
    token = token + &env::var("PAGERDUTY_TOKEN").expect("Set PAGERDUTY_TOKEN env");
    req.headers_mut().set(Token(token));
    req.headers_mut().set(Accept(vec![qitem("application/vnd.pagerduty+json;version=2".parse().unwrap())]));
    
    let a = client.request(req).and_then(|res| {
        println!("{:?}", res.status());
        // if it's not a 200 then error out
       // match res.status(){
        //    hyper::StatusCode::Ok => {
                res.body().concat2().and_then(move |body: hyper::Chunk| {
                    futures::done(f(body))
                })
            
            
           // _ => Err(From::from(format!("{}", res.status)))
        }
    
    );    
    core.run(a)?;
                                        Ok(())
}
    

fn incidents(){
    make_call("incidents?statuses%5B%5D=triggered&statuses%5B%5D=acknowledged", print_incidents).unwrap();
    }


fn oncall(){
    // let body: String;            
    // TODO: change endpoint
    make_call("oncalls?time_zone=UTC&user_ids%5B%5D=PYHMPK3&escalation_policy_ids%5B%5D=P6OGX5C&schedule_ids%5B%5D=PQJ4RJ7", print_oncall).unwrap();
    //     Ok(bod) => body = bod,
    //     Err(err) => {println!("{}", err);
    //                  process::exit(1)}
    // }
    
    // // deserialize json
    // let request_json = json::Json::from_str(&body).unwrap();
    // let response_obj = request_json.as_object().unwrap();

    // let oncalls = response_obj.get("oncalls").unwrap();
    // let oncalls_array = oncalls.as_array().unwrap();

    // if oncalls_array.len() > 0{
    //     call_loop();
    // }
}

fn main(){
    if let Ok(s) = env::var("BLOCK_BUTTON"){
        if s == "1"{
            let _ = process::Command::new("termite").arg("--hold")
                .arg("-e")
                .arg("coffee /home/daniel/Dropbox/work_scripts/vrih-pagerduty/src/vrih-pagerduty.coffee")
                .spawn()
                .unwrap_or_else(|e| { panic!("failed to execute process: {}", e)});

//            let _ = process::Command::new("xdg-open").arg("https://infectiousmedia.pagerduty.com/incidents").output().unwrap_or_else(|e| { panic!("failed to execute process: {}", e)} );
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
