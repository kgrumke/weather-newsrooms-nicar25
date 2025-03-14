# SOURCE_URL:="https://api.weather.gov/alerts/active?status=actual&area=CA&code=HWW"
# SOURCE_URL:="https://api.weather.gov/alerts/active?status=actual&area=MO"

COUNTIES := MOC189 MOC183 MOC161 ILC163 ILC119 ILC001
SOURCE_URL_BASE := "https://api.weather.gov/alerts/active?status=actual&zone="

all: clean download slack

download:
	-mkdir -p tmp
	for county in $(COUNTIES); do \
		echo "Fetching alerts for $$county..."; \
		curl --continue --progress-bar --retry 3 $(SOURCE_URL_BASE)$$county --header='accept: application/geo+json' --header='User-Agent: (stlpr.org, kgrumke@stlpr.org)' -o tmp/download_$$county.json; \
	done

# download:
# 	-mkdir tmp
# 	wget --continue --progress=dot:mega --waitretry=60 ${SOURCE_URL} \
#		--header='accept: application/geo+json' \
#		--header='User-Agent: (stlpr.org, kgrumke@stlpr.org)' \
#		-O tmp/download.json

warnings:
	node warnings.js

slack:
	node warnings-slack.js

clean:
	-rm ./tmp/download.json
