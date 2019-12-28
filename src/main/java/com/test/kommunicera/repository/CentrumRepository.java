package com.test.kommunicera.repository;

import java.util.Arrays;
import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.test.kommunicera.constants.AppConstants;
import com.test.kommunicera.model.ChildItemKey;
import com.test.kommunicera.model.RetrieveCatalogue;
import com.test.kommunicera.model.RetrieveCategory;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * Repository class responsible for calling Centrum via REST API
 */

@RequiredArgsConstructor
@Service
@Slf4j
public class CentrumRepository {

	private RestTemplate restTemplate = new RestTemplate();

	public List<RetrieveCatalogue> retrieveCatalogue(String retailUnit, String languageCode) {

		RetrieveCatalogue[] catalogues = null;
		if (retailUnit != null && languageCode != null) {
			log.info("Getting All Catalogues for RU " + retailUnit);
			String url = AppConstants.CENTRUM_BASE_URL + "/rrm-rc/" + retailUnit + "/" + languageCode + "/catalogues/";

			ResponseEntity<RetrieveCatalogue[]> response = restTemplate.getForEntity(url, RetrieveCatalogue[].class);
			catalogues = response.getBody();
		}
		return Arrays.asList(catalogues);
	}

	public List<RetrieveCategory> retrieveTopCategories(Integer catalogueId, String languageCode, String retailUnit) {
		RetrieveCategory[] categories = null;
		// Retrieve Top Level Categories
		log.info("Getting top level categories for catalogue " + catalogueId + "...");
		String url = AppConstants.CENTRUM_BASE_URL + "/rrm-rc/" + retailUnit + "/" + languageCode + "/catalogues/"
				+ catalogueId + "/top-categories";

		ResponseEntity<RetrieveCategory[]> response = restTemplate.getForEntity(url, RetrieveCategory[].class);
		categories = response.getBody();

		return Arrays.asList(categories);

	}

	public List<RetrieveCategory> retrieveChildCategories(Integer catalogueId, Integer categoryId, String languageCode,
			String retailUnit) {
		RetrieveCategory[] categories = null;
		log.info("Getting child categories for category " + categoryId + " in catalogue " + catalogueId + "...");
		final String url = AppConstants.CENTRUM_BASE_URL + "/rrm-rc/" + retailUnit + "/" + languageCode + "/catalogues/"
				+ catalogueId + "/categories/" + categoryId + "/child-categories";

		ResponseEntity<RetrieveCategory[]> response = restTemplate.getForEntity(url, RetrieveCategory[].class);
		categories = response.getBody();
		return Arrays.asList(categories);
	}

	public List<ChildItemKey> retrieveChildItemKeys(Integer catalogueId, Integer categoryId) {
		ChildItemKey[] childItemKeys = null;
		log.info("Getting child Items for category " + categoryId + " in catalogue " + catalogueId + "...");
		final String url = AppConstants.CENTRUM_BASE_URL + "/rrm-rc/" + "/catalogues/" + catalogueId + "/categories/"
				+ categoryId + "/items";

		ResponseEntity<ChildItemKey[]> response = restTemplate.getForEntity(url, ChildItemKey[].class);
		childItemKeys = response.getBody();
		return Arrays.asList(childItemKeys);
	}
}
