"""empty message

Revision ID: f529fc25f0d6
Revises: 5ea0ec1d8711
Create Date: 2021-07-30 13:38:56.345029

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'f529fc25f0d6'
down_revision = '5ea0ec1d8711'
branch_labels = None
depends_on = None


def upgrade(engine_name):
    globals()["upgrade_%s" % engine_name]()


def downgrade(engine_name):
    globals()["downgrade_%s" % engine_name]()





def upgrade_():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('partials',
    sa.Column('unique_id', sa.String(length=255), nullable=False),
    sa.Column('hostname', sa.String(length=255), nullable=False),
    sa.Column('blockchain', sa.String(length=64), nullable=False),
    sa.Column('launcher_id', sa.String(length=255), nullable=False),
    sa.Column('pool_url', sa.String(length=255), nullable=False),
    sa.Column('pool_response', sa.String(), nullable=False),
    sa.Column('created_at', sa.String(length=64), nullable=False),
    sa.PrimaryKeyConstraint('unique_id')
    )
    # ### end Alembic commands ###


def downgrade_():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_table('partials')
    # ### end Alembic commands ###


def upgrade_stats():
    # ### commands auto generated by Alembic - please adjust! ###
    pass
    # ### end Alembic commands ###


def downgrade_stats():
    # ### commands auto generated by Alembic - please adjust! ###
    pass
    # ### end Alembic commands ###
