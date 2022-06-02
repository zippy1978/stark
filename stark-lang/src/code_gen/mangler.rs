//! Mangler.
pub struct ManglerConfig<'a> {
    prefix: &'a str,
    function_type: &'a str,
}

pub struct Mangler<'a> {
    config: ManglerConfig<'a>,
}

impl<'a> Mangler<'a> {
    pub fn default() -> Self {
        Mangler {
            config: ManglerConfig {
                prefix: "__stark",
                function_type: "f",
            },
        }
    }

    /// Mangles a function name.
    pub fn mangle_function_name(&self, module_name: Option<String>, function_name: &str) -> String {
        // "main" function is never mangled !
        if module_name.is_none() && function_name == "main" {
            return function_name.to_string();
        }

        format!(
            "{}_{}_{}_{}",
            self.config.prefix,
            self.config.function_type,
            match module_name {
                Some(name) => name,
                None => "".to_string(),
            },
            function_name
        )
    }
}
