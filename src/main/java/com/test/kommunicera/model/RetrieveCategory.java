package com.test.kommunicera.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class RetrieveCategory {

	private Integer categoryId;
	private String legacyCategoryId;
	private String categoryName;
	private Integer categoryRank;
	private int childCategoryCount;
	private int childItemCount;

}
