.PHONY: helm chart

TARGET:=dist
REGISTRY:=
DATE:=`date -u +"%Y-%m-%dT%H:%M:%SZ"`
VERSION:=
CHARTVERSION:=$(shell cat VERSION)
APPVERSION:=$(shell cat APP_VERSION)
CHART_DIR=$(shell pwd)/charts/privatebin/

clean:
	rm -rf dist

chart:
	cd ${CHART_DIR} && helm package . --destination "$(TARGET)"

chartversion:
	sed -i '5 s/version:.*/version: "'${CHARTVERSION}'"/' "${CHART_DIR}/Chart.yaml"
	sed -i '6 s/appVersion:.*/appVersion: "'${APPVERSION}'"/' "${CHART_DIR}/Chart.yaml"

package: clean chartversion
	mkdir -p dist && helm package ${CHART_DIR} -d ./dist 

push: package
	helm push ./dist/*.tgz oci://${REGISTRY}
