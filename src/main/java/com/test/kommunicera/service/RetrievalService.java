package com.test.kommunicera.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.test.kommunicera.model.Category;
import com.test.kommunicera.model.ChildItemKey;
import com.test.kommunicera.model.RetrieveCatalogue;
import com.test.kommunicera.model.RetrieveCategory;
import com.test.kommunicera.repository.CentrumRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RequiredArgsConstructor
@Service
@Transactional
@Slf4j
public class RetrievalService {

	@Autowired
	private final CentrumRepository centrumRepository;

	public List<RetrieveCatalogue> retrieveCatalogue(String retailUnit, String languageCode) {
		return centrumRepository.retrieveCatalogue(retailUnit, languageCode);
	}

	public List<Category> retrieveCategory(Integer catalogueId, String retailUnit, String languageCode) {
		List<Category> categoryList = new ArrayList<>();

		List<RetrieveCategory> topLevelCategories = centrumRepository.retrieveTopCategories(catalogueId, languageCode,
				retailUnit);

		for (RetrieveCategory l1Category : topLevelCategories) {
			categoryList = populateCategoryDetails(categoryList, l1Category, retailUnit, languageCode, catalogueId);

			// L2
			if (l1Category.getChildCategoryCount() > 0) {
				List<RetrieveCategory> l2Categories = centrumRepository.retrieveChildCategories(catalogueId,
						l1Category.getCategoryId(), languageCode, retailUnit);
				for (RetrieveCategory l2Category : l2Categories) {
					// L3
					categoryList = populateCategoryDetails(categoryList, l2Category, retailUnit, languageCode,
							catalogueId);

					if (l2Category.getChildCategoryCount() > 0) {
						List<RetrieveCategory> l3Categories = centrumRepository.retrieveChildCategories(catalogueId,
								l2Category.getCategoryId(), languageCode, retailUnit);
						for (RetrieveCategory l3Category : l3Categories) {
							// L4
							categoryList = populateCategoryDetails(categoryList, l3Category, retailUnit, languageCode,
									catalogueId);
							if (l3Category.getChildCategoryCount() > 0) {
								List<RetrieveCategory> l4Categories = centrumRepository.retrieveChildCategories(
										catalogueId, l3Category.getCategoryId(), languageCode, retailUnit);
								for (RetrieveCategory l4Category : l4Categories) {
									categoryList = populateCategoryDetails(categoryList, l4Category, retailUnit,
											languageCode, catalogueId);
									// L5
									if (l4Category.getChildCategoryCount() > 0) {
										List<RetrieveCategory> l5Categories = centrumRepository.retrieveChildCategories(
												catalogueId, l4Category.getCategoryId(), languageCode, retailUnit);
										for (RetrieveCategory l5Category : l5Categories) {
											categoryList = populateCategoryDetails(categoryList, l5Category, retailUnit,
													languageCode, catalogueId);

										}
									}
								}
							}
						}
					}
				}

			}

		}
		return categoryList;
	}

	private List<Category> populateCategoryDetails(List<Category> categoryList, RetrieveCategory category,
			String retailUnit, String languageCode, Integer catalogueId) {
		Category categoryDetail = new Category();
		categoryDetail.setCategoryId(category.getCategoryId());
		categoryDetail.setCategoryName(category.getCategoryName());
		categoryDetail.setLegacyCategoryId(category.getLegacyCategoryId());
		categoryDetail.setCategoryRank(category.getCategoryRank());
		if (category.getChildCategoryCount() > 0) {
			List<RetrieveCategory> childCategories = centrumRepository.retrieveChildCategories(catalogueId,
					category.getCategoryId(), languageCode, retailUnit);
			List<Integer> childCategoriesList = new ArrayList<>();
			for (RetrieveCategory childCategory : childCategories) {
				childCategoriesList.add(childCategory.getCategoryId());
			}
			categoryDetail.setChildCategories(childCategoriesList);
		} else {
			List<ChildItemKey> childItemKeys = centrumRepository.retrieveChildItemKeys(catalogueId,
					category.getCategoryId());
			categoryDetail.setChildItemKeys(childItemKeys);
		}
		// TODO: SET Subcategory and Child Item Details
		categoryList.add(categoryDetail);
		return categoryList;
	}

}
