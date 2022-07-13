import pytest

from src.domain.exceptions.model import FileNotFound
from src.domain.models.request.model import TermModel
from src.repositories.terms.repository import (
    TermRepository,
)
from src.repositories.user.repository import UserRepository
from src.services.terms.service import TermService
from unittest.mock import patch
from pytest import mark

term_model_dummy = TermModel(file_type="term_refusal")
link_dummy = "https://www.term_link_here.com"
user_document_dummy = {"terms": {"term_refusal": {"version": 4}}}


@mark.asyncio
@patch.object(
    TermRepository,
    "get_term_link_by_version",
    return_value=link_dummy,
)
@patch.object(TermService, "_TermService__get_user_term_version", return_value="4")
async def test_get_user_signed_term_url(get_user_mock, get_term_link_mock):
    result = await TermService.get_user_signed_term_url(term_model_dummy, "unique-id")
    assert get_user_mock.called
    assert get_term_link_mock.called
    assert result == link_dummy


@mark.asyncio
@patch.object(
    UserRepository,
    "find_user",
    return_value=user_document_dummy,
)
async def test___get_user_term_version(find_user_mock):
    result = await TermService._TermService__get_user_term_version(
        term_model_dummy, "unique-id"
    )
    assert find_user_mock.called
    assert result == 4
