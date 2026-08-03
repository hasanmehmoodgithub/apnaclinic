import '../../domain/entities/search_entity.dart';
import '../models/search_response_model.dart';


class SearchMapper {
  static SearchContentEntity toEntity(SearchResponseModel model) {
    return SearchContentEntity(
      recentSearches: model.recentSearches
          .map(
            (item) => SearchRecentEntity(
          title: item.title,
          subtitle: item.subtitle,
        ),
      )
          .toList(),
      popularSearches: model.popularSearches,
      suggestions: model.suggestions
          .map(
            (item) => SearchSuggestionEntity(
          title: item.title,
          subtitle: item.subtitle,
          sectionType: mapSectionType(item.sectionType),
        ),
      )
          .toList(),
      sections: model.sections
          .map(
            (section) => SearchSectionEntity(
          title: section.title,
          type: mapSectionType(section.sectionType),
          results: section.results
              .map(
                (result) => SearchResultEntity(
              id: result.id,
              title: result.title,
              subtitle: result.subtitle,
              description: result.description,
              imageUrl: result.imageUrl,
              rating: result.rating,
              fee: result.fee,
              price: result.price,
              oldFee: result.oldFee,
              hospital: result.hospital,
              sampleType: result.sampleType,
              providerLabel: result.providerLabel,
              primaryActionLabel: result.primaryActionLabel,
              date: result.date,
              time: result.time,
              providerLogo: result.providerLogo,
              labLogo: result.labLogo,
              publicId: result.publicId,
              tenantId: result.tenantId,
              doctorId: result.doctorId,
              cityId: result.cityId,
              packageId: result.packageId,
              packageName: result.packageName,
            ),
          )
              .toList(),
        ),
      )
          .toList(),
    );
  }
}
