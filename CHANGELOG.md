* Tolk 1.4.00
  * Upgraded to work with Rails 4

* Tolk 1.3.11
  * Bugkfix on tolk locale dump path

* Tolk 1.3.10
  * UI Improvments (@laurens)
  * Export class refactoring (@modsognir)
  * Text strip (@csaura)

* Tolk 1.3.9
  * Activate deserialize_symbols option of SafeYaml, if not, Rails date_select will be broken...

* Tolk 1.3.8
  * Update safe_yaml to 0.8.6, fixes issue : invalid value for Float(): "." (#29)
  * Fixed download locale yml file (@fcsonline)
  * Added interpolations keys validations (@fcsonline)
  * Added an alert when leave the page with non saved data (@fcsonline)
  * Added statistics endpoint (@fcsonline)
  * Fixed Portuguese Brazilian locale code (@fcsonline)

* Tolk 1.3.7
  * Removing a js warning of scriptaculous
  * Adding Gemfile.lock for tests to pass
  * Use safe_load (Larry Lv)
  * Remove warning of safe_yaml

* Tolk 1.3.6
  * Better sync (@elDub)
  * Better safe_yaml warnings support (@mangelajo)
  * Better safe_yaml warnings support (@mangelajo)

* Tolk 1.3.5
  * Fixed CVE-2013-0156 (Lawrence Pit)
  * Added possibility to refresh locale ui (@ck3g)
  * Namespace locale parameter (laurense)
  * Removed an old Hax which delayed this release for 1 week...

* Tolk 1.3.4
  * fixed a boolean flags entry

* Tolk 1.3.3
  * fixed a incompatible character encoding error

* Tolk 1.3.2
  * fixed a crash and made tests passing (gshilin)

* Tolk 1.3.0
  * Improved header (bquorning)
  * Locales are ordered by name in locales/index
  * Tolk ignore files with name of type xxx.en.yml
  * Default mapping use http://en.wikipedia.org/wiki/List_of_ISO_639-1_codes
  * Adding a config file for Tolk in the hosted application
    * Allow to config Mappings
    * Allow to config dump_path

* Tolk 1.2.0 [May 16th, 2012]
  * Adding search within key (ZenCocoon)
  * Update for Rails 3.2.3 whitelist attributes compatibility


* Tolk 1.1.0 [May 15th, 2012]
  * Update for Rails 3.2 compatibility
  * Added Travis CI

* Tolk 1.0.0 [June 6th, 2010]
  * First public release as a Rails 3 engine gem
