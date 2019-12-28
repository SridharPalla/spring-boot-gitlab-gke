package com.test.kommunicera.constants;

public final class SwaggerConstants {

	public static final String CATALOG_REST_API = "Catalogue INFORMATION REST APIs";
	public static final String CONTROLLER_PKG = "com.ingka.rc.kommunicera.controller";
	public static final String PATH_SELECTOR = "/.*";
	public static final String VERSION = "1.0.0";
	public static final String FIND_ALL_DESC = "-- To view the list of available catalogues";
	public static final String FIND_ALL_CATEGORY_DESC = "-- To view the list of available categories and item for a catalogue";
	public static final String HTTP_200_MSG = "Successfully retrieved list";
	public static final String HTTP_401_MSG = "You are not authorized to view the resource";
	public static final String HTTP_403_MSG = "Accessing the resource you were trying to reach is forbidden";
	public static final String HTTP_404_MSG = "The resource you were trying to reach is not found";

	private SwaggerConstants() {
		// restrict instantiation
	}

}
