<!---
	
	Copyright 2011, Bob Silverberg & John Whish
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent output="false" name="ServerRuleValidator_NotRegex" extends="AbstractServerRuleValidator" hint="I am responsible for performing the NotRegex validation.">

	<cffunction name="validate" returntype="any" access="public" output="false" hint="I perform the validation returning info in the validation object.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object created by the business object being validated." />
		<cfargument name="locale" type="string" required="yes" hint="The locale to use to generate the default failure message." />

		<cfset var Parameters = arguments.validation.getParameters() />
		<cfset var theRegex = "" />
		<cfset var theValue = arguments.validation.getObjectValue() />
		<cfset var args = [arguments.validation.getPropertyDesc()] />

		<cfif StructKeyExists(Parameters,"serverRegex")>
			<cfset theRegex = Parameters.serverRegex />
		<cfelseif StructKeyExists(Parameters,"regex")>
			<cfset theRegex = Parameters.regex />
		<cfelse>			
			<cfthrow type="validatethis.server.ServerRuleValidator_NotRegex.missingParameter"
			message="Either a regex or a serverRegex parameter must be defined for a regex rule type." />
		</cfif>

		<cfif shouldTest(arguments.validation) AND REFind(theRegex,theValue) NEQ 0>
			<cfset fail(arguments.validation,variables.messageHelper.getGeneratedFailureMessage("defaultMessage_NotRegex",args,arguments.locale)) />
		</cfif>
	</cffunction>
	
</cfcomponent>