import streamlit as st
from core.database import SessionLocal
from models.models import Analysis

def get_analysis_by_id(analysis_id: int):
    db = SessionLocal()
    try:
        analysis_record = db.query(Analysis).filter(Analysis.id == analysis_id).first()
        if not analysis_record:
            return None

        stages = []
        for stage in analysis_record.stages:
            stages.append({
                "id": stage.id,
                "stage_name": stage.stage_name,
                "status": stage.status,
                "result": stage.result,
                "error_details": stage.error_details,
                "started_at": stage.started_at,
                "ended_at": stage.ended_at
            })

        return {
            "analysis_id": analysis_record.id,
            "conversation_id": analysis_record.conversation_id,
            "satisfaction": analysis_record.satisfaction,
            "summary": analysis_record.summary,
            "improvement": analysis_record.improvement,
            "status": analysis_record.status,
            "stages": stages,
            "created_at": analysis_record.created_at,
            "updated_at": analysis_record.updated_at
        }

    finally:
        db.close()

# STREAMLIT UI
st.title("Analysis Preview")

analysis_id = st.number_input("Analysis ID:", min_value=1, value=1, step=1)

if st.button("Load Analysis"):
    data = get_analysis_by_id(analysis_id)
    if data:
        st.subheader("Analysis JSON:")
        st.json(data)
    else:
        st.error(f"Analysis with ID={analysis_id} not found.")
