{**
 * archiveForm.tpl
 *
 * Copyright (c) 2005-2006 Alec Smecher and John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Basic archive settings under site administration.
 *
 * $Id$
 *}

{if $archiveId}
	{assign var="helpTopicId" value="admin.archiveForm"}
	{assign var="pageTitle" value="admin.archives.editArchive"}
{elseif $isUserLoggedIn}
	{assign var="helpTopicId" value="admin.archiveForm"}
	{assign var="pageTitle" value="admin.archives.addArchive"}
{else}
	{assign var="helpTopicId" value="index.addArchive"}
	{assign var="pageTitle" value="navigation.addArchive"}
{/if}

{include file="common/header.tpl"}

{if $archiveId}
<ul class="menu">
	<li class="current"><a href="{url path=$archiveId}">{translate key="admin.archives.editArchive"}</a></li>
	<li><a href="{url op="manage" path=$archiveId}">{translate key="admin.archives.manage"}</a></li>
</ul>
{/if}

<br />

<script type="text/javascript">
<!--

{literal}
function selectHarvester() {
	document.archiveForm.action="{/literal}{if $archiveId}{url op="editArchive" anchor="archiveForm" path=$archiveId escape=false}{else}{url op="editArchive" anchor="archiveForm" escape=false}{/if}{literal}";
	document.archiveForm.submit();
}

{/literal}
// -->
</script>

<a name="archiveForm"/>
<form name="archiveForm" method="post" action="{url op="updateArchive"}">
{if $archiveId}
<input type="hidden" name="archiveId" value="{$archiveId}" />
{/if}

{include file="common/formErrors.tpl"}

<table class="data" width="100%">
	<tr valign="top">
		<td width="20%" class="label">{fieldLabel name="title" key="archive.title" required="true"}</td>
		<td width="80%" class="value"><input type="text" id="title" name="title" value="{$title|escape}" size="40" maxlength="120" class="textField" /></td>
	</tr>
	<tr valign="top">
		<td class="label">{fieldLabel name="description" key="archive.description"}</td>
		<td class="value"><textarea name="description" id="description" cols="40" rows="10" class="textArea">{$description|escape}</textarea></td>
	</tr>
	<tr valign="top">
		<td class="label">{fieldLabel name="url" key="archive.url" required="true"}</td>
		<td class="value">
			<input type="text" id="url" name="url" value="{$url|escape}" size="40" maxlength="120" class="textField" />
			<br/>
			{translate key="admin.archives.form.url.description"}
		</td>
	</tr>

	{if $isUserLoggedIn}{* Only administrators are allowed to enter public archive IDs *}
		<tr valign="top">
			<td class="label">{fieldLabel name="url" key="archive.publicArchiveId"}</td>
			<td class="value">
				<input type="text" id="publicArchiveId" name="publicArchiveId" value="{$publicArchiveId|escape}" size="20" maxlength="40" class="textField" />
				<br/>
				{translate key="admin.archives.form.publicArchiveId.description"}
			</td>
		</tr>
	{/if}

	{if !$isUserLoggedIn}{* Display Captcha test *}
		{if $captchaEnabled}
			<td class="label" valign="top">{fieldLabel name="captcha" required="true" key="common.captchaField"}</td>
			<td class="value">
				<img src="{url page="admin" op="viewCaptcha" path=$captchaId}" alt="" /><br />
				<span class="instruct">{translate key="common.captchaField.description"}</span><br />
				<input name="captcha" id="captcha" value="" size="20" maxlength="32" class="textField" />
				<input type="hidden" name="captchaId" value="{$captchaId|escape:"quoted"}" />
			</td>
		{/if}
	{/if}

	<tr>
		<td class="label">{fieldLabel name="harvesterPluginName" key="archive.type" required="true"}</td>
		<td><select onchange="selectHarvester()" name="harvesterPluginName" id="harvesterPluginName" size="1" class="selectMenu">
			{foreach from=$harvesters item=harvester}
				<option {if $harvester->getName() == $harvesterPluginName}selected="selected" {/if}value="{$harvester->getName()}">{$harvester->getProtocolDisplayName()}</option>
			{/foreach}
		</select></td>
	</tr>

	{call_hook name="Template::Admin::Archives::displayHarvesterForm" plugin=$harvesterPluginName}
</table>

<p><input type="submit" value="{translate key="common.save"}" class="button defaultButton" /> <input type="button" value="{translate key="common.cancel"}" class="button" onclick="document.location.href='{url op="archives"}'" /></p>

</form>

<p><span class="formRequired">{translate key="common.requiredField"}</span></p>

{include file="common/footer.tpl"}
