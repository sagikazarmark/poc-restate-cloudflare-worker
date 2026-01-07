use http_body_util::BodyExt;
use restate_sdk::prelude::Endpoint;
use worker::*;

mod examples;
use examples::*;

#[event(fetch)]
async fn fetch(req: HttpRequest, _env: Env, _ctx: Context) -> Result<http::Response<Body>> {
    let endpoint = Endpoint::builder()
        .bind(CounterImpl.serve())
        // .bind(FailureExampleImpl.serve())
        .bind(GreeterImpl.serve())
        // .bind(RunExampleImpl(reqwest::Client::new()).serve())
        .build();

    let response = endpoint.handle(req);

    let (parts, body) = response.into_parts();

    let body2 = worker::Body::from_stream(body.into_data_stream())?;

    Ok(http::Response::from_parts(parts, body2))
}
