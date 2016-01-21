 * Rails 5.0 beta support

* Tolk 1.9.3
 * Fix for a wrong order of requires (@wpp)

* Tolk 1.9.2
 * Fix for initializer in the gemfile (@lime)

* Tolk 1.9.0
 * Allow not to sync files of type devise.fr.yml (only translate your work via tolk)

* Tolk 1.8.1
 * Backport for fix #108 (@lime)

* Tolk 1.8.0
 * Allow to exclude locales from other gems in config ! (@tsai146)
 * Make Tolk able to use either Kaminari or will_paginate (@lime)

* Tolk 1.7.0
 * Rails 4.2 compatibility (@dnrce)
 * Fixed parameter handling in dump_yaml task (@grk)

* Tolk 1.6.0
  * Rails 4.2 beta compatibility (@cnrce)

* Tolk 1.6.0
  * Rails 4.0 and 4.1 compatibility (@grk @zoombody)
  * Cleanup for the gem and safe_yaml, makes tolk a better citizen (@grk)
  * Updating preloader calls (@AlexStein)

* Tolk 1.5.02
  * Ruby and gem requirements are much cleaner (@zoombody)
  * Rails version support is more clear (@zoombody)
  * Tests are also cleaner ! (@zoombody)

* Tolk 1.5.01
  * Loose dependency on safe_yaml

* Tolk 1.5.00
  * Remove all warning related to Rails 4
  * Ability to dum a single locale (@raouldevil)
  * Strong params (@jmccartie)


* Tolk 1.4.00
  * Upgraded to work with Rails 4 (@jamesw)

* Tolk 1.3.12
  * A few bugfixes
  * libraries added to precompiled files (@ressu)
  * set primary_locale correctly (@devolute)
  * typo on the doc (jankeesw)
  * don't allow nil translations (insales)

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
