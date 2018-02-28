# owasp-zap-glue-ci-images
OWASP [Zap](https://github.com/zaproxy/zaproxy) is a great security tool that can easily be used in a CI/CD environment. [Glue](https://github.com/OWASP/glue) is another tool from OWASP that aimed to ease the integration of security tools into CI. You can read more in this [blog post](https://blog.solutotlv.com/dynamic-security-testing-made-easy?utm_source=github), where I've explained how to easily integrate Zap and Glue into CI/CD pipeline and build a valuable security tests.

This repo contains images that make the process of integrating Zap and Glue into the ci simpler, by setting up various configuration that are required for the integration. The code is based on the work done by [Nataly Shrits](https://github.com/nataly87s), on [Tweek](https://github.com/Soluto/tweek) project. 

## Using this repo
To easily add security tests to your project, follow the following steps:
* Copy all compose files and scripts folder to your project root folder
* Copy `zap/run_test.sh` to your blackbox tests folder. 
  * Also change the Dockerfile of your blackbox: It should now run this script instead.
* Copy `zap/install_dependencies.sh` to your blackbox tests folder.
  * It's for debian based images, but if your images is based upon alpin - comment line 3 and uncomment line 4.
  * Add the following lines to the begging of your blackbox`s Dockerfile:
```
COPY install_dependencies.sh ./
RUN dotnet restore && \
    ./install_dependencies.sh
```
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
  * Make sure your tests actually running (e.g. look for your test output)
  * Look for the following line, indicating that Zap's scan completed: `ZAP scan completed`.
  * If you see the following line `No URL was accessed by ZAP`, it means that you did not proxy your tests via Zap.
* Now, run security tests by running: `./scripts/run_security_tests.sh`
  * On the first run you will some some errors, usually false positive. This is an example output:
```
Logfile nil?
calling scan
Running scanner
Loading scanner...
Mounting http://api with #<Glue::URLMounter:0x000055962d27f740>
Mounted http://api with #<Glue::URLMounter:0x000055962d27f740>
Processing target...http://api
Running tasks in stage: wait
Running tasks in stage: mount
Running tasks in stage: file
Running tasks in stage: code
Running tasks in stage: live
live - Zap - #<Set:0x000055962d91a4d8>
Running tasks in stage: done
##teamcity[message text='Report failed tests for each finding with severity equal or above Low' status='NORMAL']
##teamcity[testSuiteStarted name='Zap']
##teamcity[testStarted name='ZAPhttp://api/Storable and Cacheable Content' captureStandardOutput='true']
Source: ZAPhttp://api/
Details: Url: http://api/ Param:
 Evidence:
 https://tools.ietf.org/html/rfc7234
https://tools.ietf.org/html/rfc7231
http://www.w3.org/Protocols/rfc2616/rfc2616-sec13.html (obsoleted by rfc7234)
Solution: Validate that the response does not contain sensitive, personal or user-specific information.  If it does, consider the use of the following HTTP response headers, to limit, or prevent the contentbeing stored and retrieved from the cache by another user:
Cache-Control: no-cache, no-store, must-revalidate, private
Pragma: no-cache
Expires: 0
This configuration directs both HTTP 1.0 and HTTP 1.1 compliant caching servers to not store the response, and to not retrieve the response (without validation) from the cache, in response to a similar request.
CWE: 524        WASCID: 13      Rule ID: 10049
##teamcity[testFailed name='ZAPhttp://api/Storable and Cacheable Content' message='Severity Low' details='The response contents are storable by caching components such as proxy servers, and may be retrieveddirectly from the cache, rather than from the origin server by the caching servers, in response to similar requests from other users.  If the response data is sensitive, personal or user-specific, this may result in sensitive information being leaked. In some cases, this may even result in a user gaining complete control of the session of another user, depending on the configuration of the caching components in use in their environment. This is primarily an issue where "shared" caching servers such as "proxy" caches are configured on the local network. This configuration is typically found in corporate or educational environments, for instance.']
##teamcity[testFinished name='ZAPhttp://api/Storable and Cacheable Content']
##teamcity[testSuiteFinished name='Zap']
```
* Now it's time to customize the security tests:
  * Ignore irrelevant rules by adding them to line 26 on `zap/run_test.sh`. You can find the rule id in the test output, like you see above - look for `Rule ID: 10049`.
  * Ignore irrelevant URLs by adding them to line 29 on `zap/run_test.sh`. You can find the URL in the test name.
  * Ignore specific issues by marking them as `ignore` on `glue.json`. This is an example `glue.json:
```
{
  "ZAPhttp://api/Storable and Cacheable Content": "new",
  "ZAPhttp://api/X-Content-Type-Options Header MissingX-Content-Type-Options": "new",
  "ZAPhttp://api/api/v1/reports/webStorable and Cacheable Content": "new",
  "ZAPhttp://api/api/v1/reports/androidStorable and Cacheable Content": "new",
  "ZAPhttp://api/api/v1/reports/iosStorable and Cacheable Content": "new"
}
```
Just find the relevant issue (by the test name, which is the same as the key in the JSON) and change `new` to `ignore`. 
You can also postpone issues by setting the value to `postpone:%d-%m-%Y`, with the desired date.
The issue will be ignored until this date.
* Fix the rest of the issues!
* Now all the tests should pass until a new issue found!