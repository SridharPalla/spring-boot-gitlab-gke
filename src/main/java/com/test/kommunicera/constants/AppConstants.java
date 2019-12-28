package com.test.kommunicera.constants;

public final class AppConstants {

	public static final String CENTRUM_BASE_URL = "http://centrum-dev.endpoints.ingka-cm-api-dev.cloud.goog";
	// public static final String CENTRUM_BASE_URL =
	// "http://centrum-stable.endpoints.ingka-cm-api-dev.cloud.goog";
	// public static final String CENTRUM_BASE_URL = "http://localhost:8080";

	public static final String SYSTEM_USER_NAME = "irw_importer";
	public static final String CATALOG_REST_API = "Catalogue Management REST API";
	public static final String BASE_REQUEST_MAPPING = "/rrm-rc/{retail-unit}/{language-code}/";
	public static final String CATALOG_REQUEST_MAPPING = "/catalogues";
	public static final String CATALOG_DATE_REQUEST_MAPPING = "/catalogues/{from-date}/{to-date}";
	public static final String NO_CATALOGUE_DETAILS = "Currently no Catalogue information is available ";
	public static final String NO_CATEGORY_DETAILS = "Currently no Category information is available ";

	private AppConstants() {
		// restrict instantiation
	}

}
