mod static_files;

#[cfg(feature = "ssr")]
#[tokio::main]
async fn main() -> miette::Result<()> {
    use axum::Router;
    use leptos::logging;
    use leptos_axum::{generate_route_list, LeptosRoutes};
    use miette::IntoDiagnostic;

    use {{crate_name}}::app::App;

    let leptos_options = leptos::get_configuration(None)
        .await
        .into_diagnostic()?
        .leptos_options;
    let listen_addr = leptos_options.site_addr;

    let routes = generate_route_list(App);

    let app = Router::new()
        .leptos_routes(&leptos_options, routes, App)
        .fallback(static_files::file_or_error_handler)
        .with_state(leptos_options);

    let listener = tokio::net::TcpListener::bind(&listen_addr)
        .await
        .into_diagnostic()?;
    logging::log!("listening on http://{}", listen_addr);
    axum::serve(listener, app.into_make_service())
        .await
        .into_diagnostic()?;

    Ok(())
}

#[cfg(not(feature = "ssr"))]
fn main() {}
