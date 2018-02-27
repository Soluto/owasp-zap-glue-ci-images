# owasp-zap-glue-ci-images
OWASP [Zap](https://github.com/zaproxy/zaproxy) is a great security tool that can easily be used in a CI/CD environment. [Glue](https://github.com/OWASP/glue) is another tool from OWASP that aimed to ease the integration of security tools into CI. You can read more in this [blog post](https://blog.solutotlv.com/dynamic-security-testing-made-easy?utm_source=github), where I've explained how to easily integrate Zap and Glue into CI/CD pipeline and build a valuable security tests.

This repo contains images that make the process of integrating Zap and Glue into the ci simpler, by setting up various configuration that are required for the integration. The code is based on the work done by [Nataly Shrits](https://github.com/nataly87s), on [Tweek](https://github.com/Soluto/tweek) project. 

## Using this repo
To easily add security tests to your project, follow the following steps:
* Copy all compose files and scripts folder to your project root folder
* Copy `zap/run_test.sh` to your blackbox tests folder. 
  * Also change the Dockerfile of your blackbox: It should now run this script instead.
* Modify `run_test.sh`: Change line 9 to actualy running your tests (e.g. `dotnet test`).
* Modify the docker-compsoe files:
  * `docker-compose.yaml`: Change line 6 to point to your blackbox Dockerfile
  * `docker-compose.local.yaml`: Change line 5 to match to your API Dockerfile path
  * Add other required services (mocks etc) to `docker-compose.yaml`. Don't forget adding dependencies.
* Proxy your blackbox test via Zap. You need to configure the code running the test to use a proxy:
  * dotnet:
  ```
    var url = Environment.GetEnvironmentVariable("API_URL") ?? "http://localhost:5000";
    ServicePointManager.ServerCertificateValidationCallback += (sender, cert, chain, sslPolicyErrors) => true;

    var proxyUrl = Environment.GetEnvironmentVariable("PROXY_URL");
    var handler = new HttpClientHandler();

    if (proxyUrl != null)
    {
        handler.Proxy = new WebProxy(proxyUrl, false);
    }

    HttpClient = new HttpClient(handler) {BaseAddress = new Uri(url)};
  ```
* Run your tests by running `./scripts/run_tests.sh`:
  * Make sure your tests actually running
  * A new folder named `zap` should be created
* Now, run security tests by running: `./scripts/run_security_tests.sh`
  * You should see some failures in TC format, if not - maybe something is broken, check the logs.
* Now it's time to customize the security tests:
  * Ignore irrelevant rules by adding them to line 32 on `zap/run_test.sh`.
  * Ignore irrelevant rules by adding them to line 35 on `zap/run_test.sh`.
  * Ignore specific issues by marking them as `ignore` on `glue.json`.
  * Fix the rest of the issues!
* Now all the tests should pass until a new issue found!