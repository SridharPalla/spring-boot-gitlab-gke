package com.test.kommunicera.model;

import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Category {

	private Integer categoryId;
	private String legacyCategoryId;
	private String categoryName;
	private Integer categoryRank;
	private List<Integer> childCategories;
	private List<ChildItemKey> childItemKeys;

}
