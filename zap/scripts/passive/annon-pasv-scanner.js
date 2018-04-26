/**
 * This script checks whether resources (URLs) are successfully accessed (Status 200 - Ok)
 * on a request which did not have an authorization header.
 *
 * Note: This is a passive script not an active script: As such the Authorization header 
 * is not forcefully removed prior to making the request. This script will only alert if a 
 * request is proxied (or initiated via the spider(s), etc) which does not have an Authorization
 * header, and subsequently passively scanned.
 * Source: https://github.com/zaproxy/zaproxy/issues/4602#issuecomment-382106798
 */

function scan(ps, msg, src) 
{
    alertRisk = 1
    alertReliability = 2
    alertTitle = "Resource Allows Anonymous Access"
    alertDesc = "The web/application server allowed access without any Authorization header on the request."
    alertSolution = "Ensure that the application appropriately requires authentication and authorization."

    cweId = 0
    wascId = 0

    url = msg.getRequestHeader().getURI().toString();
    headers = msg.getRequestHeader().getHeaders("Authorization");
    
    // Might want to check here to see if the URL is in scope: msg.isInScope()
    if (headers == null && msg.getResponseHeader().getStatusCode() == 200)
    {
        ps.raiseAlert(alertRisk, alertReliability, alertTitle, alertDesc, url, '', '', '', alertSolution, headers, cweId, wascId, msg);
    }
    
}