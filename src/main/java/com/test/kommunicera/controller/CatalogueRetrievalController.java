package com.test.kommunicera.controller;

import static com.test.kommunicera.constants.AppConstants.CATALOG_REQUEST_MAPPING;
import static com.test.kommunicera.constants.AppConstants.NO_CATALOGUE_DETAILS;
import static com.test.kommunicera.constants.SwaggerConstants.FIND_ALL_DESC;
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
import com.test.kommunicera.model.RetrieveCatalogue;
import com.test.kommunicera.service.RetrievalService;

import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping(AppConstants.BASE_REQUEST_MAPPING)
@Slf4j
@RequiredArgsConstructor
public class CatalogueRetrievalController {

	@Autowired
	RetrievalService retrievalService;

	@ApiOperation(value = FIND_ALL_DESC, response = RetrieveCatalogue.class)
	@ApiResponses(value = { @ApiResponse(code = 200, message = HTTP_200_MSG),
			@ApiResponse(code = 401, message = HTTP_401_MSG), @ApiResponse(code = 403, message = HTTP_403_MSG),
			@ApiResponse(code = 404, message = HTTP_404_MSG) })
	@GetMapping(CATALOG_REQUEST_MAPPING)
	ResponseEntity<List<RetrieveCatalogue>> retrieveCatalogue(@PathVariable(value = "retail-unit") String retailUnit,
			@PathVariable(value = "language-code") String languageCode) {
		log.info("Welcome to the Controller. All the catalogues for the market will be retrieved soon!");
		List<RetrieveCatalogue> response = retrievalService.retrieveCatalogue(retailUnit, languageCode);
		if (response == null)
			try {
				throw new ResourceNotFoundException(NO_CATALOGUE_DETAILS);
			} catch (ResourceNotFoundException e) {
				e.printStackTrace();
			}
		log.info("Retrieval finished! Number of Catalogue: " + response.size());
		return ResponseEntity.ok().body(response);
	}

}
