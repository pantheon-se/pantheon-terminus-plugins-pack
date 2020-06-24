# Pantheon Site Portfolio Management Guide

The following example demonstrates usage of the Mass Update and Mass Run plugins to easily apply 
upstream updates in bulk.

When the responsbility of deploying code changes across a large number of sites is a technically 
demanding task. Pantheon suggest you let the machines do those tasks for you!

Our command-line tool called Terminus allows you to manage one or all sites in your organization with 
powerful commands. Terminus also supports third-party plugins that extend it's functionality by 
adding new commands. For instructions on how to install Terminus plugins, see Extend with Plugins (link here).

## Installation & Setup
### Step 1. Install Terminus
Terminus must be installed (link here) prior to running the following plugins starter script. Follow 
those instructions before proceeding.

### Step 2. Add Plugins
Instead of installing each plugin one-by-one, run the following commands to install all the necessary plugins 
at once. The expected time is should take is under 2-minutes.

```
cd ~
curl -o https://github.com/Pantheon-SE/INSERT-FINAL-REPO-URL-HERE
./terminus-plugin-mega-pack-setup.sh
```
##### Plugins
The list of plugins the script installs are the following:
 1. terminus-mass-update -- Terminus plugin that applies upstream updates to a list of sites.
 1. terminus-mass-run -- run Terminus commands on multiple Pantheon sites.
 1. terminus-build-tools-plugin -- collection of commands useful for projects making use of an external Git provider and Continuous Integration (CI).
 1. terminus-site-status-plugin -- displays the status of all available Pantheon site environments.
 1. terminus-composer-plugin -- plugin for running Composer commands on a Pantheon site.
 1. terminus-quicksilver-plugin -- help you get started quickly with Quicksilver.
 1. terminus-site-clone -- facilitate cloning sites on Pantheon.
 1. terminus-rsync-plugin -- provides a quick shortcut for rsync-ing files to and from a Pantheon site.
 1. terminus-filer-plugin -- open Pantheon sites using an SFTP client.
 1. terminus-pancakes-plugin -- open any Pantheon site database using a SQL GUI client.

##### Optional plugins
 1. terminus-autocomplete-plugin -- helps provide tab completion for commands. Requires setup: https://github.com/terminus-plugin-project/terminus-autocomplete-plugin (Optional)
 1. pantheon-systems/terminus-newrelic-data-plugin -- fetches metric data from the New Relic API. https://github.com/pantheon-systems/terminus-newrelic-data-plugin

## Best-Practice Workflow
Custom Upstreams workflow on Pantheon is designed for effeciency and reliability when managing Web CMS codebases. 
The following steps are an overview of the typical best-practices and workflow when maintaining a portfolio of websites.
 1. Upstream repository receives code changes we'll eventually distribute across multiple sites. 
 1. Apply upstream changes down to each site per upstream.
 1. Deploy those changes on each site from Dev, Test, then Live.
 1. Test each environment when it gets an update, via automation or human contact.
 1. Run backups per site and per environment. Before and after is fine, if that's your thing.

#### Step details
Your team easily satistfies Step #1 by making any Git commit(s) to the upstream repository, a normal day-to-day operation.

Steps #2 & #3 are handled by our Terminus bulk commands listed below. We'll go over those commands in a moment.

Step #4 is done by manual labor, automation, or a combination therein. If you want to automate this step, Pantheon has a service 
called Managed Updates (insert link) that helps automate daily update checks by running visual QA tests with automatic screenshots and anlaysis.

Step #5 is a wise habit to adopt. Terminus commands and plugins make triggering backups across multiple sites and each environment simple. No need 
to visit each site one-by-one to do any of the above. That's the benefit of WebOps!


## Pantheon Custom Upstream
Pantheon Upstreams gives you the ability to customize where and when your CMS customizations get distributed, 
all with little overhead. Pantheon also provides easy-to-apply updates with built-in testing environments 
to ensure quick security fixes with confidence.

The command that will list the sites your organization/user have control over is `terminus org:site:list --format=list`. Feel free to 
run that command now if you want to see the list of sites before we proceed.


### Applying updates to multiple sites
After any code change is made to the upstream repository our dashboard and platform will detect those changes and offer 
our easy one-click update option to apply the new code changes down to that site. When dealing with multiple sites we can't 
spend time clicking one-by-one.

#### Step 1. Dry-run
Using the *Mass Update* plugin, we'll start by using the `--dry-run` option to review available updates without applying them:

```
terminus org:site:list --format=list | terminus site:mass-update:apply --accept-upstream --dry-run
```

The output should be similar to this:
```
[notice] Found 3 sites.
[notice] Fetching the list of available updates for each site...
[notice] 3 sites need updates.
[warning] Cannot apply updates to your-first-site because the dev environment is not in git mode.
[DRY RUN] Applying 2 updates to your-second-site
[DRY RUN] Applying 10 updates to your-other-site
Resolve warning messages shown in the --dry-run output by setting the connection mode to Git for each applicable site:
```

###### Warning
Not a big deal since we're just getting started, but please note the following command will permanently 
delete all uncommitted file changes uploaded to the site. If you made any changes before this and wish 
to keep any changes made while in SFTP mode, commit your work before proceeding. If you're interested 
in how to switch between SFTP & Git modes, there's a command for that: `terminus connection:set my-site.dev git`

#### Step 2. Bulk Updates
You can see the updates reflected in each site's dashboard. In fact, you can see our tools updating each site if you're 
viewing the dashboard when running any of these Terminus commands. The next command we run will apply the mass 
update by removing the `--dry-run` option:

```
terminus org:site:list --format=list | terminus site:mass-update:apply --accept-upstream
```

That's it!

All the sites listed will run their respective updates. Our commands provide ways to filter updates to 
only apply to a certain subset of sites by Tag, Upstream, or any other dimension we provide.


### How to run commands on multiple sites

Use the *Mass Run* plugin to issue the same command across multiple sites. Just like before, we can use 
the `--dry-run` option to review any command feedback before applying that change.

Each example below is to showcase the varying commands available for site admins.

#### Backup multiple sites on one command: 
```
terminus site:list --format=list | terminus backup:mass:create
```

#### Deploy code across multiple sites on one command: 
```
terminus site:list --format=list | terminus env:mass:deploy
```

#### Switch connection mode betwen SFTP or Git for multiple sites:
```
terminus site:list --format=list | terminus connection:mass:set sftp
terminus site:list --format=list | terminus connection:mass:set git
```

There are other bulk commands available. Please review our Terminus commands list and documentation for more info. 
