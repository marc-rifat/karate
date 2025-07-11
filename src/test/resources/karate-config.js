function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
    env: env,
    myVarName: 'someValue'
  }
  if (env == 'dev') {
    config.baseUrl = 'https://jsonplaceholder.typicode.com';
  } else if (env == 'staging') {
    config.baseUrl = 'https://staging-api.example.com';
  } else if (env == 'prod') {
    config.baseUrl = 'https://api.example.com';
  }
  return config;
}