from rest_framework.pagination import PageNumberPagination


class PlacePagination(PageNumberPagination): #Here make the pagination in app. Do with max 20 items.
    page_size = 5
    page_size_query_param = 'page_size'
    max_page_size = 5