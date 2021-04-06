<div class="row-fluid">
<div class="span10 offset1">
    <h2>There was a problem with your request</h2>
<cfif getEnvironment() neq 'dev'>
        <div class="alert alert-block alert-error">
            <h4>Error</h4>
            <p>Sorry, there was a problem with your request. We have notified the system administrator.</p>
        </div>
<cfelse>
        <div class="alert alert-block alert-error">
            <h4>Error</h4>
            <p>There was an error - check out the details below.</p>
        <cfoutput>
                <div>
                <dl class="dl-horizontal">
                    <dt>Action:</dt>
                <dd>#structKeyExists( request, 'failedAction') ? request.failedAction : 'Unknown'#</dd>
                <dt>Error:</dt>
            <dd>#request.exception.cause.message#</dd>
                <dt>Type:</dt>
            <dd>#request.exception.cause.type#</dd>
                <dt>Details:</dt>
            <dd>#request.exception.cause.detail#</dd>
            </dl>
            </div>
        </cfoutput>
        <cfdump var="#request.exception#" />
        </div>

</cfif>
</div>
</div>