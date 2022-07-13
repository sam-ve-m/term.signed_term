from src.domain.models.request.model import TermModel
from src.repositories.terms.repository import (
    TermRepository,
)
from src.repositories.user.repository import UserRepository


class TermService:
    @staticmethod
    async def __get_user_term_version(term: TermModel, unique_id: str) -> str:
        user_data = await UserRepository.find_user({"unique_id": unique_id})
        term_version = user_data["terms"][term.file_type.value]["version"]
        return term_version

    @classmethod
    async def get_user_signed_term_url(cls, term: TermModel, unique_id: str) -> str:
        term_type = term.file_type
        term_version = await cls.__get_user_term_version(term, unique_id)
        link = await TermRepository.get_term_link_by_version(
            term=term_type, version=term_version
        )
        return link
