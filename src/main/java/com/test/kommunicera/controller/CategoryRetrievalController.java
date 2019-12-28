package com.test.kommunicera.controller;

import static com.test.kommunicera.constants.SwaggerConstants.CATALOG_REST_API;
import static com.test.kommunicera.constants.SwaggerConstants.FIND_ALL_CATEGORY_DESC;
import static com.test.kommunicera.constants.SwaggerConstants.HTTP_200_MSG;
import static com.test.kommunicera.constants.SwaggerConstants.HTTP_401_MSG;
import static com.test.kommunicera.constants.SwaggerConstants.HTTP_403_MSG;
import static com.test.kommunicera.constants.SwaggerConstants.HTTP_404_MSG;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.test.kommunicera.constants.AppConstants;
import com.test.kommunicera.exception.ResourceNotFoundException;
import com.test.kommunicera.model.Category;
import com.test.kommunicera.service.RetrievalService;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping(AppConstants.BASE_REQUEST_MAPPING)
@Api(value = CATALOG_REST_API)
@Slf4j
@RequiredArgsConstructor
public class CategoryRetrievalController {

	@Autowired
	RetrievalService retrievalService;

	@ApiOperation(value = FIND_ALL_CATEGORY_DESC, response = Category.class)
	@ApiResponses(value = { @ApiResponse(code = 200, message = HTTP_200_MSG),
			@ApiResponse(code = 401, message = HTTP_401_MSG), @ApiResponse(code = 403, message = HTTP_403_MSG),
			@ApiResponse(code = 404, message = HTTP_404_MSG) })
	@GetMapping("/catalogues/{catalogue-id}")
	ResponseEntity<List<Category>> retrieveCategory(@PathVariable(value = "catalogue-id") Integer catalogueId,
			@PathVariable(value = "retail-unit") String retailUnit,
			@PathVariable(value = "language-code") String languageCode) {
		log.info(
				"Welcome to the Controller. All the categories and items for the catalogue in the specified market will be retrieved soon!");
		List<Category> response = retrievalService.retrieveCategory(catalogueId, retailUnit, languageCode);
		if (response == null)
			try {
				throw new ResourceNotFoundException(AppConstants.NO_CATEGORY_DETAILS);
			} catch (ResourceNotFoundException e) {
				e.printStackTrace();
			}
		log.info("Retrieval finished! Number of Categories: " + response.size());
		return ResponseEntity.ok().body(response);
	}

}
