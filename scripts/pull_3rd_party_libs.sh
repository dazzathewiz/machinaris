#!/bin/bash
#
# Due to complaints about JS CDNs, this pulls all JS libs into web/static/3rd_party folder
#

# Bootstrap Icons
BSI_VERSION=1.10.2
BOOTSTRAP_VERSION=5.2.3
BASEPATH=${JS_LIBS_BASEPATH:-/machinaris/web/static/3rd_party}

# List of other css/js links
LIST="
https://cdn.datatables.net/1.13.1/css/dataTables.bootstrap5.css
https://cdn.datatables.net/1.13.1/js/dataTables.bootstrap5.js
https://cdn.datatables.net/1.13.1/js/jquery.dataTables.js
https://cdn.jsdelivr.net/npm/chart.js@4.0.1/dist/chart.umd.min.js
https://cdn.jsdelivr.net/npm/chartjs-adapter-luxon@1.3.0/dist/chartjs-adapter-luxon.umd.min.js
https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.2.0/dist/chartjs-plugin-datalabels.min.js
https://cdn.jsdelivr.net/npm/jquery@3.6.1/dist/jquery.min.js
https://moment.github.io/luxon/global/luxon.min.js"

mkdir -p $BASEPATH
for url in $LIST ; do
  wget -nv -O ${BASEPATH}/$(basename $url) "$url"
done

# Bootstrap Icons
wget -nv -O ${BASEPATH}/bsi-icons.zip "https://github.com/twbs/icons/releases/download/v${BSI_VERSION}/bootstrap-icons-${BSI_VERSION}.zip" && \
unzip -q -o ${BASEPATH}/bsi-icons.zip -d $BASEPATH/ && \
mv $BASEPATH/bootstrap-icons-${BSI_VERSION} $BASEPATH/icons && \
rm -f ${BASEPATH}/bsi-icons.zip

# Bootstrap
wget -O ${BASEPATH}/bs.zip -nv "https://github.com/twbs/bootstrap/releases/download/v${BOOTSTRAP_VERSION}/bootstrap-${BOOTSTRAP_VERSION}-dist.zip" && \
unzip -q -o -j ${BASEPATH}/bs.zip -d $BASEPATH/ bootstrap-${BOOTSTRAP_VERSION}*/css/bootstrap.min.css* bootstrap-${BOOTSTRAP_VERSION}*/js/bootstrap.bundle.min.js*  && \
rm -f ${BASEPATH}/bs.zip

# Leaflet and plugins
wget -O ${BASEPATH}/leaflet.zip -nv "https://leafletjs-cdn.s3.amazonaws.com/content/leaflet/v1.9.3/leaflet.zip" && \
unzip -q -o ${BASEPATH}/leaflet.zip -d $BASEPATH/ && \
rm -f ${BASEPATH}/leaflet.zip
wget -O ${BASEPATH}/leaflet-layervisibility.js -nv "https://unpkg.com/leaflet-layervisibility/dist/leaflet-layervisibility.js"
sed -i 's/\/\/# sourceMapping.*//g' ${BASEPATH}/leaflet-layervisibility.js

# Pull localization files for DataTables.js
mkdir -p $BASEPATH/i18n/
LANGS=$(grep -oP "LANGUAGES = \[\K(.*)\]" $BASEPATH/../../default_settings.py | cut -d ']' -f 1 | tr -d \'\" | tr -d ' ')
IFS=',';
for lang in $LANGS; 
do
  if [[ "$lang" == 'en' ]]; then
      continue  # No separate translation files for default locale
  fi

  lang_hyphen=${lang/_/-}
  wget -nv -O ${BASEPATH}/i18n/datatables.${lang}.json https://raw.githubusercontent.com/DataTables/Plugins/master/i18n/${lang_hyphen}.json
  if [ $? == 0 ]; then
    echo "Successfully downloaded DataTables language translations for ${lang}."
  else
    echo "ERROR: Failed to download DataTables language translations for ${lang}."
  fi
done
